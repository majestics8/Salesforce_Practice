public class ApexPractice5DEC
{

    public static void Leadstatuscheck(
        List<Lead> ldlist,
        Map<Id, Lead> oldmap
    )
    {
        Set<Id> ldid = new Set<Id>();

        // UAT VERSION — SAME LINE BUT DIFFERENT CONTENT
        Id pfid = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Analytics Cloud Integration User'
            LIMIT 1
        ].Id;

        User uu = [
            SELECT Id
            FROM User
            WHERE ProfileId = :pfid
            LIMIT 1
        ];

        for (Lead newll : ldlist)
        {
            Lead oldll = oldmap.get(newll.Id);

            if (
                newll.status == 'Working - Contacted'
                &&
                oldll.status == 'Open - Not Contacted'
            )
            {
                newll.ownerId = uu.Id;
            }

            if (newll.status == 'Closed - Converted')
            {
                ldid.add(newll.Id);
            }
        }

        if (ldid.isEmpty())
        {
            return;
        }

        Set<Id> opentask = new Set<Id>();

        for (Task tt : [
            SELECT WhoId
            FROM Task
            WHERE Status != 'Not Started'
            AND Status != 'Completed'
            AND WhoId IN :ldid
        ])
        {
            opentask.add(tt.WhoId);
        }

        for (Lead ld : ldlist)
        {
            if (opentask.contains(ld.Id))
            {
                ld.addError('The Lead cannot be updated — UAT');
            }
        }
    }
}
