/**
 * Copyright (C) 2010 Sopra Steria Group (movalys.support@soprasteria.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
package com.adeuza.movalysfwk.mf4mdd.w8.generators;

import org.dom4j.Document;

import com.a2a.adjava.languages.w8.generators.EntityInterfaceGenerator;
import com.a2a.adjava.languages.w8.xmodele.MW8ImportDelegate;
import com.a2a.adjava.xmodele.IDomain;
import com.a2a.adjava.xmodele.IModelDictionary;
import com.a2a.adjava.xmodele.IModelFactory;
import com.a2a.adjava.xmodele.MAssociation;
import com.a2a.adjava.xmodele.MEntityImpl;
import com.a2a.adjava.xmodele.MEntityInterface;
import com.a2a.adjava.xmodele.XProject;
import com.adeuza.movalysfwk.mf4mdd.w8.xmodele.MF4WImportDelegate;

public class MF4WEntityInterfaceGenerator extends EntityInterfaceGenerator{
	
	@Override
	protected Document createDocument(MEntityInterface p_oInterface,
			MEntityImpl p_oClass,
			XProject<IDomain<IModelDictionary, IModelFactory>> p_oMProject) {
		
		Document r_xEntityInterface = super.createDocument(p_oInterface, p_oClass, p_oMProject);
		
		MF4WImportDelegate oImportDlg = new MF4WImportDelegate(this);
		if(p_oClass.getAssociations() != null && p_oClass.getAssociations().size() > 0){
			for(MAssociation oAssosiation : p_oClass.getAssociations()){
				if(oAssosiation.getRefClass() != null){
					oImportDlg.addImport(MW8ImportDelegate.MW8ImportCategory.ENTITIES.name(), oAssosiation.getRefClass().getPackage().getFullName());
				}
			}
		}
		r_xEntityInterface.getRootElement().add(oImportDlg.toXml());

		return r_xEntityInterface ;
	}
}
